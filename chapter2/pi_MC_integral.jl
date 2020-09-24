using LinearAlgebra: norm

function compute(;n_iter=1_000_000, print_step=1_000)
    sum_y = 0.0

    for i in 1:n_iter
        x = rand()
        y = sqrt(1 - x * x)
        sum_y += y

        if i % print_step == 0
            println("$i $(sum_y / i)")
        end
    end

    println("est : $(sum_y/n_iter)")
    println("true: $(pi/4)")
end

function compute_v2(;n_iter=1_000_000)
    sum_y = 0.0

    x = rand(n_iter)
    y = sqrt.(1 .- x .^ 2)
    est = sum(y) / n_iter

    println("est : $est")
    println("true: $(pi/4)")
end

compute(print_step=Inf)
compute_v2()