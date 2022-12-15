
function getdim(searchspace::AtomicSearchSpace)
    searchspace.dim
end

"""
    in(item, searchspace) -> Bool

Determine whether an item is in the given searchspace.
"""
Base.in(x, s::AbstractSearchSpace) = isinspace(x, s)
Base.in(x::Missing, s::AbstractSearchSpace) = missing
