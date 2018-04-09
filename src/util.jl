lose_colons(idxs, idxc::Colon, idxsc...) = (first(idxs), lose_colons(Base.tail(idxs), idxsc...)...)
lose_colons(idxs, idxc, idxsc...) = (idxc, lose_colons(Base.tail(idxs), idxsc...)...)
lose_colons(::Tuple{}) = ()
lose_colons(idxs, ::Tuple{}) = error("Argument Tuples must be of equal length")
lose_colons(::Tuple{}, idxc, idxsc...) = error("Argument Tuples must be of equal length")

_idxs(A, dim, idxs) = idxs
_idxs(A, dim, idxs::Colon) = indices(A,dim)
_idxs(A::AbstractArray, idxs) = lose_colons(indices(A), idxs...)
_idx_shape(A::AbstractArray, idxs) = map(length, _idxs(A, idxs))

_index_slice(A::AbstractArray{T,2}, dim1::Colon, dim2::Colon) where {T} = A
_index_slice(A::AbstractArray{T,2}, dim1, dim2) where {T} = A[dim1,dim2]
_index_slice(A::AbstractArray{T,3}, dim1::Colon, dim2::Colon, dim3::Colon) where {T} = A
_index_slice(A::AbstractArray{T,3}, dim1, dim2, dim3) where {T} = A[dim1,dim2,dim3]

#This is an odd place to keep these.  Could see about PR to AxisArrays?
axisspacing(A::AxisArray) = map(step, axisvalues(A))
match_axisspacing(B::AbstractArray{T,N}, A::IM) where {T,N, IM<:ImageMeta} = ImageMeta(match_axisspacing(B, data(A)), properties(A))
function match_axisspacing(B::AbstractArray{T,N}, A::AxisArray{T2,N}) where {T,T2,N}
    sp = axisspacing(A)
    nms = axisnames(A)
    newaxs = []
    for ax = 1:length(sp)
        u = unit(sp[ax])
        push!(newaxs, Axis{nms[ax]}(linspace(0.0*u, (size(B,ax)-1)*sp[ax], size(B,ax))))
    end
    return AxisArray(B, newaxs...)
end