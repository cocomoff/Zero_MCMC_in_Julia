using Distributions
using Plots
gr()

function compute(S; n_iter=100, step_size=0.5)
    x = 0.0
    n_accept = 0

    values = Float64[]

    # main loop
    for i in 1:n_iter
        backup_x = x
        action_init = S(x)
        dx = rand()
        dx = (dx - 0.5) * step_size * 2;
        x += dx

        action_fin = S(x)
        if exp(action_init - action_fin) > rand()
            n_accept += 1
        else
            x = backup_x
        end

        push!(values, x)
    end

    println("$x $(n_accept/n_iter)")
    values
end

function plot_values_in_hist(values; n_bins=50)
    f = plot(size=(400, 300))
    histogram!(f, collect(values), bins=n_bins, normalize=true)
    savefig(f, "chapter4/histogram1_n$(length(values)).png")
end

function plot_values_in_hist_with_ans(values; n_bins=50)
    f = plot(size=(400, 300))
    histogram!(f, collect(values), bins=n_bins, normalize=true, label="sample")

    # real values (ans) of S(x) = (x^2)/2
    dnorm = Normal()
    x = -2.0:0.01:2.0
    y = pdf.(dnorm, x)
    plot!(x, y, color=:red, label="ans")

    savefig(f, "chapter4/histogram1_n$(length(values)).png")
end

S(x) = 0.5 * x * x

for n_iter in [10^3, 10^4, 10^5]
    values = compute(S, n_iter=n_iter);
    plot_values_in_hist_with_ans(values)
end
