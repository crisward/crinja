class Crinja::Node
  class Note < Node
    def block?
      true
    end

    def trim_right?
      token.trim_right
    end

    def trim_right_after_end?
      token.trim_right
    end
  end
end
