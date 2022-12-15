abstract type AbstractVariable end

"""
    Variable(name, searchspace)

A structure to define a variable in the search space: `searchspace`.
"""
struct Variable{N, S <: AbstractSearchSpace} <: AbstractVariable
    name::N
    searchspace::S
end

"""
    @var x in searchspace

A macro to define a [`Variable`](@ref) for in the given search space.
"""
macro var(ex)
    if length(ex.args) != 3 || ex.args[1] ∉ [:in, :∈]
        throw(ArgumentError("Expression not valid."))
    end

    var_name = ex.args[2]
    value = ex.args[3]
    
    quote
        local searchspace = $(esc(value))
        $(esc(var_name)) = Variable($(QuoteNode(var_name)), searchspace)
    end
end

