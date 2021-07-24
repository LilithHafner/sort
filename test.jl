function small_test(alg; stable=true, n=5)
    for i in 1:n
        for j in 1:(2^i)
            test([[1&(j >> k)] for k in 1:i], alg, stable)
        end
    end
end

function rnd_test(alg; stable=true, n=100, trials=10)
    for tiral in 1:trials
        test([[rand(1:n)] for i in 1:rand(1:n)], alg, stable)
    end
end

function test(x, alg, stable)
    y, z = copy(x), copy(x)
    sort!(x; alg=alg)
    sort!(y)
    try
        @assert x == y
        if stable
            @assert all(a === b for (a,b) in zip(x,y))
        end
    catch
        global fail_input = z
        global fail_algorithm = alg
        global fail_stable = stable
        rethrow()
    end
end

small_test(MergeSort)
rnd_test(MergeSort)
small_test(QuickSort, stable=false)
rnd_test(QuickSort, stable=false)
small_test(QuickSort)# Dispatches to InsertionSort
rnd_test(QuickSort)# Fails. QuickSort is not stable.
