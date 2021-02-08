


class StmtList
  attr_accessor :stmt, :stmt_list

  def initialize(stmt,stmt_list)
    @stmt = stmt
    @stmt_list = stmt_list
  end

  def eval
    if @stmt.class == Return_stmt #stops further evaling if a statement is a return
        return @stmt.eval
    end
    @stmt.eval
    @stmt_list.eval

  end
end


class Return_stmt
  attr_accessor :eval, :value
  def initialize(a)
    @value = a
  end
  def eval
    return @value.eval
  end
end


class Scope
  attr_accessor :currentscope, :scope_counter

  def initialize
    @scopevariables = [{}]
    @currentscope = @scopevariables[0]
    @scope_counter = 0

  end

  def move_up
    if @scope_counter > 0
        @currentscope = @scopevariables[@scope_counter-1]
        @scopevariables.pop()
        @scope_counter -= 1
    end
  end

  def move_down
    if @scope_counter == 0
      @scopevariables[0] = @currentscope.clone
    end


    @scopevariables << {}
    @scope_counter += 1
    @scopevariables[@scope_counter] = @scopevariables[@scope_counter-1].clone
    @currentscope = @scopevariables[@scope_counter].clone
  end
  def get_scope
    @scope_counter
  end
end



class Func_call_stmt
    def initialize(a,b = nil)
      @id = a
      @args = b
    end
    def eval
      @@scope.move_down
        if @args != nil #calls function with arguments
          result = @@function_keys[@id].func_call(@args)
        else
          result = @@function_keys[@id].func_call
        end
      @@scope.move_up
      return result
    end
end

@@function_keys = {} #global hash with function objects

class Func_def_stmt
    attr_accessor :params

    def initialize(a,b = {},c)
      @id = a
      @params = b
      @stmt_list = c

    end
    def eval
      @@function_keys[@id] = self
    end


    def func_call(args = nil) #"eval" function for when a method is called

      if args != nil
        @args = args
        0.upto(@params.length-1) do |para|

          tmp = @args[para].eval
          @@scope.currentscope[@params[para].intern] = tmp

        end
        temp = @stmt_list.eval
      else
        temp = @stmt_list.eval
      end

      return temp
    end
end


class For_stmt
    def initialize(var,condition,expr,statements)
      @var = var
      @condition = condition
      @expr = expr
      @statements = statements
    end
    def eval
        @var.eval
        while @condition.eval
            @statements.eval
            @expr.eval
        end

    end
end


class While_stmt
    def initialize(condition,statements)
      @condition = condition
      @statements = statements
    end
    def eval
        while @condition.eval
            @statements.eval
        end
    end
end


class Assign_stmt

  def initialize(a,b)
    @var = a
    @value = b
  end

  def eval
      @@scope.currentscope[@var.var] = @value.eval
      return @value.eval
  end
end

class Get_Var_stmt
  attr_accessor :eval
  attr_reader :var
  def initialize(a)
    @var = a.intern
  end
  def eval
      return @@scope.currentscope[@var] != nil ? @@scope.currentscope[@var] : "Undefined"
  end
end


class Add_expr
  attr_accessor :eval
  def initialize(a,b,c)
    @left_term = a
    @operator = b
    @right_term = c
  end

  def eval
    return @left_term.eval.send(@operator, @right_term.eval)
  end

end

class Mult_expr
    attr_accessor :eval
    def initialize(a,b,c)
        @left_term = a
        @operator = b
        @right_term = c
    end

    def eval
        return @left_term.eval.send(@operator, @right_term.eval)
    end
end


# ===================== VARIABLES =======================

class Digit
    attr_accessor :eval
    def initialize(a)
      @term = a
    end
    def eval
        return instance_eval(@term)
    end
end

class String
    attr_accessor :eval
    def initialize(a)
      @term = a
    end

    def eval
        return @term
    end
end

class Boolean
    def initialize value
      @value = value
    end
    def eval
      return @value
    end
end


# ===================== LOGIC =======================

class And_expr
  def initialize(a,b)
      @left_term = a
      @right_term = b
  end

  def eval
      return @left_term.eval == @right_term.eval
  end
end

class Or_expr
  def initialize(a,b)
      @left_term = a
      @right_term = b
  end

  def eval
      return @left_term.eval || @right_term.eval
  end
end

class Not_expr
  def initialize value
    @value = value
  end
  def eval
    return !@value.eval
  end
end


class Comp_expr

  attr_accessor :eval
  def initialize(a,x,b)
      @left_term = a
      @operator = x
      @right_term = b
  end

  def eval
    return @left_term.eval.send(@operator, @right_term.eval)
  end
end


# ===================== I/O =======================

class Print
  attr_accessor :eval
  def initialize value
    @value = value
  end
  def eval
    print @value.eval
  end
end

class Println
  attr_accessor :eval
  def initialize value
    @value = value
  end
  def eval
      puts @value.eval
  end
end



@@prev_if_val = false

class If # condition

  def initialize(a,b)
      @condition = a
      @statements = b
  end

  def eval
    @@prev_if_val = false

    if(@condition.eval)

      return @statements.eval

    else
        @@prev_if_val = true
    end
  end
end

class Elif # condition
  def initialize(a,b)
      @condition = a
      @statements = b
  end

  def eval

    if (@@prev_if_val)
        if(@condition.eval)


            @@prev_if_val = false
          return @statements.eval
        end
    end
  end
end

class Else # condition
  def initialize(a)
      @statements = a
  end
  def eval
  if (@@prev_if_val)
      @@prev_if_val = false
      return @statements.eval
    end
  end

end






















#
