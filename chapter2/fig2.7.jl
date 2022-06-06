using Plots
using Distributions
using LinearAlgebra
using Statistics
gr()

function compute(; a=2, n_iter=10_000, print_step=1_000)
    sum_y = 0.0

    values = zeros(Float64, n_iter)
    for i in 1:n_iter
        x = rand(Uniform(-a, a))
        y = 1 / sqrt(2 * pi) * exp(-x^2 / 2)
        sum_y += y

        values[i] = sum_y / i * 2 * a

        if i % print_step == 0
            println("$i $(sum_y / i)")
        end
    end

    println("est : $(sum_y/n_iter * 2 * a)")
    values
end

function draw()
    v1 = compute(; a=2)
    v2 = compute(; a=10)
    v3 = compute(; a=100)
    v4 = compute(; a=1000)

    f = plot(size=(500, 300))
    plot!(f, v1)
    plot!(f, v2)
    plot!(f, v3)
    plot!(f, v4)
    savefig("output.png")
end