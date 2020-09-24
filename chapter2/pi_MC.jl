using LinearAlgebra: norm

function compute(;n_iter=1_000_000, print_step=1_000)
    n_in = 0

    for i in 1:n_iter
        xy = rand(2)
        (norm(xy) < 1) && (n_in += 1)
        (i % print_step == 0) && println("$i $(n_in / i)")
    end

    println("true: $(pi/4)")
end

compute()
