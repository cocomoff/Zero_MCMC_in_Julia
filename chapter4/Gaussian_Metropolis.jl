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


function fig41()
    S(x) = 0.5 * x * x

    for n_iter in [10^3, 10^4, 10^5]
        values = compute(S, n_iter=n_iter);
        plot_values_in_hist_with_ans(values)
    end
end

function fig42()
    S(x) = 0.5 * x * x
    N = 10^7
    n_step = 1000
    values = compute(S, n_iter=N);

    # compute <x> and <x^2> on log spaces
    plot_i = exp10.(range(2, 7, length=50))
    seq_q1 = Float64[] # <x>
    seq_q2 = Float64[] # <x^2>

    for p in plot_i
        values = compute(S, n_iter=round(p))
        push!(seq_q1, mean(values))
        push!(seq_q2, mean(values .^ 2))
    end

    f = plot(size=(700, 500), xscale=:log)
    plot!(f, plot_i, seq_q1, color=:red, lw=3, label="mean")
    plot!(f, plot_i, seq_q2, color=:blue, lw=3, label="var")
    plot!(f, plot_i, [1 for _ in 1:length(plot_i)], color=:blue, lw=1, label="")
    plot!(f, plot_i, [0 for _ in 1:length(plot_i)], color=:red, lw=1, label="")
    savefig(f, "chapter4/fig4.2.png")

end

function fig43()
    S(x) = 0.5 * x * x
    n_iter = 100000
    step_size = 0.5
    x = 0.0
    n_accept = 0

    values = Float64[]

    # ずれたサンプルを取るための分布
    bad_dist = Uniform(-0.5, 1.0)

    # main loop
    for i in 1:n_iter
        backup_x = x
        action_init = S(x)
        x += rand(bad_dist)

        action_fin = S(x)
        if exp(action_init - action_fin) > rand()
            n_accept += 1
        else
            x = backup_x
        end

        push!(values, x)
    end


    f = plot(size=(400, 300))
    histogram!(f, values, bins=50, normalize=true, label="sample")

    # real values (ans) of S(x) = (x^2)/2
    dnorm = Normal()
    x = -2.0:0.01:2.0
    y = pdf.(dnorm, x)
    plot!(x, y, color=:red, label="ans")

    savefig(f, "chapter4/fig4.3.png")
end


# fig41()
# fig42()
fig43()