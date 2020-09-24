using LinearAlgebra: norm

function compute(;n_iter=1_000_000, print_step=1_000)
    sum_z = 0.0
    n_in = 0

    for i in 1:n_iter
        xy = rand(2)
        (norm(xy) > 1) && continue

        n_in += 1
        z = sqrt(1 - xy[1] * xy[1] - xy[2] * xy[2])
        sum_z += z

        if i % print_step == 0
            println("$i $(sum_z / n_in * 2 * pi)")
        end
    end

    println("est : $(sum_z / n_in * 2 * pi)")
    println("true: $(4 * pi / 3)")
end

compute(print_step=100000)