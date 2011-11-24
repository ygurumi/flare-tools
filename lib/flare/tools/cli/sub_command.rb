# -*- coding: utf-8; -*-
# Authors::   Kiyoshi Ikehara <kiyoshi.ikehara@gree.co.jp>
# Copyright:: Copyright (C) Gree,Inc. 2011. All Rights Reserved.
# License::   NOTYET

require 'flare/util/logging'
require 'flare/util/interruption'

module Flare
  module Tools
    module Cli
      class SubCommand
        include Flare::Util::Logging
        include Flare::Util::Interruption

        @@myname = {}
        @@desc = {}
        @@usage = {}

        def self.to_sym
          myname
        end

        def self.myname(myname = nil)
          if myname.nil? then @@myname[name] else @@myname[name] = myname end
        end

        def self.usage(usage = nil)
          if usage.nil?
            @@usage[name] = "" unless @@usage.has_key?(name)
            @@usage[name]
          else
            @@usage[name] = usage
          end
        end

        def self.desc(desc = nil)
          if desc.nil?
            @@desc[name] = "" unless @@desc.has_key?(name)
            @@desc[name]
          else
            @@desc[name] = desc
          end
        end

        def myname
          myname = @@myname[self.class.name]
          if myname.nil? then "" else myname end
        end

        def self.to_s
          self.to_sym.to_s
        end

        def setup(opt)
          raise "setup"
        end
        
        def initialize
          super
        end
        
        def execute(config, *args)
          raise "execute"
        end
      end
    end
  end
end


