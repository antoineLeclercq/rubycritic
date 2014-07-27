require "parser/current"
require "rubycritic/analysers/helpers/ast_node"

module Rubycritic

  class ModulesLocator
    def initialize(analysed_module)
      @analysed_module = analysed_module
    end

    def first_name
      names.first
    end

    def names
      return name_from_path if @analysed_module.methods_count == 0
      names = node.get_module_names
      if names.empty?
        name_from_path
      else
        names
      end
    end

    private

    def node
      Parser::CurrentRuby.parse(content) || AST::EmptyNode.new
    rescue Parser::SyntaxError => error
      AST::EmptyNode.new
    end

    def content
      File.read(@analysed_module.path)
    end

    def name_from_path
      [file_name.split("_").map(&:capitalize).join]
    end

    def file_name
      @analysed_module.pathname.basename.sub_ext("").to_s
    end
  end

end
