# -*- coding: utf-8; -*-
# Authors::   Kiyoshi Ikehara <kiyoshi.ikehara@gree.net>
# Copyright:: Copyright (C) GREE, Inc. 2011.
# License::   MIT-style


require 'flare/util/logger'
require 'logger'

# 
module Flare
  module Util

    # == Description
    # Logger is a custom logging class.
    class DefaultLogger < Flare::Util::Logger
      def initialize(logger)
        @logger = ::Logger.new(STDOUT)
        @logger.level = ::Logger::WARN
      end

      def info(msg)
        @logger.info(msg)
      end

      def warn(msg)
        @logger.warn(msg)
      end

      def trace(msg)
        @logger.debug(msg)
      end

      def error(msg)
        @logger.info(msg)
      end

      def fatal(msg)
        @logger.info(msg)
      end

      def debug(msg)
        @logger.debug(msg)
      end

      def console?
        true
      end
    end

  end
end
