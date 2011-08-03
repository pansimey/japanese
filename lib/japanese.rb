# -*- coding: utf-8 -*-

require 'yaml'

module Japanese
  class PosString < String
    def initialize(string)
      super
      self.freeze
    end

    def dup
      self.to_s
    end
  end

  module Conjugatable
    def conjugate(form)
      raise "form '#{form}' is not defined" unless @ending.key?(form)
      self.sub(/#{@ending['基本形']}$/u){''} + @ending[form]
    end

    def +(latter)
      if latter.respond_to?(:connectable_form)
        connect(latter)
      else
        super
      end
    end

    private
    def connect(latter)
      conjugate(latter.connectable_form) + latter
    end
  end

  class Verb < PosString
    file_dir = File.dirname(File.expand_path(__FILE__))
    conf_path = file_dir + '/japanese/verb.yml'
    @@ending = YAML.load_file(conf_path)
    include Conjugatable
    def initialize(string, ctype)
      @ctype = ctype
      @ending = @@ending[ctype]
      super(string)
    end

    private
    def connect(latter)
      conjugate(latter.connectable_form) + accept_former(latter)
    end

    def accept_former(latter)
      rendaku_able?(latter) ? rendaku(latter) : latter
    end

    def rendaku_able?(latter)
      @ctype[/^五段・[ガナバマ]行$/] && latter.connectable_form == '連用タ接続'
    end

    def rendaku(latter)
      rendaku_map = {'た' => 'だ', 'ち' => 'じ', 'て' => 'で', 'と' => 'ど'}
      latter.sub(/^./, rendaku_map)
    end
  end

  class AuxiliaryVerb < PosString
    def initialize(string, cform)
      @connectable_form = cform
      super(string)
    end
    attr_reader :connectable_form
  end
end
