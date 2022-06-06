using Plots
using LinearAlgebra
using Statistics
gr()

function compute(; n_iter=10_000, print_step=1_000)
    n_in = 0

    values = Float64[]

    for i in 1:n_iter
        xy = rand(2)
        (norm(xy) < 1) && (n_in += 1)
        (i % print_step == 0) && println("$i $(n_in / i)")
        push!(values, n_in / i)
    end

    println("true: $(pi/4)")

    values
end

function draw_error(; n_trial=100, n_iter=10_000, sep=100)
    logs = zeros(Float64, n_trial, n_iter)
    for i in 1:n_trial
        logs[i, :] = compute(; n_iter=n_iter, print_step=Inf)
    end

    vec_means = zeros(Float64, sep)
    vec_stds = zeros(Float64, sep)
    for i in 1:sep
        vec_means[i] = mean(logs[:, i*sep])
        vec_stds[i] = std(logs[:, i*sep])
    end

    f = plot(size=(500, 500))
    scatter!(f, vec_means, yerror=vec_stds)
    savefig("output.png")

end

compute();
