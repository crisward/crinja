class Crinja::Statement
  class Filter < Statement
    property target : Statement

    include ArgumentsList

    def initialize(token : Crinja::Lexer::Token, @name_token : Crinja::Lexer::Token, @target)
      super(token)
      target.parent = self
    end

    def name
      @name_token.value
    end

    def evaluate(env : Environment) : Type
      filter = resolve_filter(env)

      arguments = Arguments.new(env)
      arguments.target = resolve_target(env)

      varargs.each do |stmt|
        arguments.varargs << stmt.value(env)
      end

      kwargs.each do |k, stmt|
        arguments.kwargs[k] = stmt.value(env)
      end

      value = nil
      begin
        value = filter.call(arguments)
      rescue err : TypeCastError
        raise TypeError.new(err.message, err)
      end
      value
    end

    def resolve_filter(env)
      env.filters[name]
    end

    def resolve_target(env)
      target.value(env)
    end
  end
end
