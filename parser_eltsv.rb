#    Based on Fluentd ltsv parser plugin https://docs.fluentd.org/parser/ltsv
#    extending it with capability to lowercase record keys and autotype for record values
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end 
  def nan?
    self !~ /^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/
  end    
end

require 'fluent/plugin/parser'

module Fluent
  module Plugin
    class LabeledTSVParser < Parser
      Plugin.register_parser('eltsv', self)

      desc 'The delimiter character (or string) of TSV values'
      config_param :delimiter, :string, default: "\t"
      desc 'Lowercase record keys'
      config_param :lowercase, :bool, default: false
      desc 'autotype for record key values'
      config_param :autotype, :bool, default: false
      desc 'The delimiter pattern of TSV values'
      config_param :delimiter_pattern, :regexp, default: nil
      desc 'The delimiter character between field name and value'
      config_param :label_delimiter, :string, default: ":"

      config_set_default :time_key, 'time'

      def configure(conf)
        super
        @delimiter = @delimiter_pattern || @delimiter
      end

      def parse(text)
        r = {}
        text.split(@delimiter).each do |pair|
          if pair.include? @label_delimiter
            key, value = pair.split(@label_delimiter, 2)
            if @lowercase
              key = key.downcase
            end
            if @autotype
              val = value.to_s
              if val.is_i?
                value = val.to_i
              elsif val.nan?
                value = val
              else
                value = val.to_f
              end
            end
            
            r[key] = value
          end
        end
        time, record = convert_values(parse_time(r), r)
        yield time, record
      end
    end
  end
end
