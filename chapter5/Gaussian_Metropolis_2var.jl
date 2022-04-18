using Distributions
using Plots
gr()

function compute(S; n_iter=10000, step_size=[0.5, 0.5], print_step=1000)
    xy = Float64[0.0, 0.0]
    backup_xy = Float64[0.0, 0.0]
    dxy = Float64[0.0, 0.0]
    n_accept = 0
    values = zeros(Float64, n_iter, 2)

    # main loop
    for i in 1:n_iter
        backup_xy[1] = xy[1]
        backup_xy[2] = xy[2]
        action_init = S(xy)

        dxy[1] = rand()
        dxy[2] = rand()
        dxy .-= 0.5
        dxy .*= (2 * step_size)
        xy .+= dxy
        action_fin = S(xy)

        if exp(action_init - action_fin) > rand()
            n_accept += 1
        else
            xy[1] = backup_xy[1]
            xy[2] = backup_xy[2]
        end

        values[i, 1] = xy[1]
        values[i, 2] = xy[2]

        if print_step > 1 && i % print_step == 0
            println("$i $(xy[1]) $(xy[2]) $(n_accept/i)")
        end
    end
    values
end

function sample()
    S(xy) = 0.5 * (xy[1] * xy[1] + xy[2] * xy[2] + xy[1] * xy[2])

    N = 10^6
    values = compute(S, n_iter=N, print_step=10^5)

    # 10ステップ毎だけのサンプル
    step = 100
    indices = 1:step:N
    f = plot(size=(400, 400))
    scatter!(f, values[indices, 1], values[indices, 2], marker=:cross, label="")
    plot!(f, -3:0.01:3, 3:-0.01:-3, lw=0.5, color=:red, label="")
    savefig(f, "chapter5/fig5.1.png")
end

function fig51()
    S(xy) = 0.5 * (xy[1] * xy[1] + xy[2] * xy[2] + xy[1] * xy[2])

    N = 10^6
    values = compute(S, n_iter=N, print_step=10^5)

    # 10ステップ毎だけのサンプル
    step = 100
    indices = 1:step:N
    f = plot(size=(400, 400))
    scatter!(f, values[indices, 1], values[indices, 2], marker=:cross, label="")
    plot!(f, -3:0.01:3, 3:-0.01:-3, lw=0.5, color=:red, label="")
    savefig(f, "chapter5/fig5.1.png")
end

function fig53(; n_trial=100)
    # functions
    S(xy) = 0.5 * (xy[1]^2 + xy[2]^2 + xy[1] * xy[2])
    Sp(x) = (2 + tanh(x)) / 3

    ranges = 1000:2000:(2*10^5)
    results = zeros(Float64, length(ranges), n_trial)
    for (idn, N) in enumerate(ranges)
        for k in 1:n_trial
            values = compute(S, n_iter=N, print_step=-1)
            vec_values_x = Sp.(values[:, 1])
            results[idn, k] = mean(vec_values_x)
        end
    end

    # plot
    f = plot(size=(600, 400), margin=2Plots.cm, ylims=(0.63, 0.70))
    plot!(f, ranges, mean(results, dims=2), ribbon=std(results, dims=2), fillalpha=0.5, label=nothing)
    savefig("chapter5/fig5.3.png")
end

function fig54(; n_trial=100)
    # functions
    S(xy) = 0.5 * (xy[1]^2 + xy[2]^2 + xy[1] * xy[2])
    Sb(y) = (y <= 2) ? 0 : (y^2) / 2

    ranges = 1000:2000:(2*10^5)
    results = zeros(Float64, length(ranges), n_trial)
    for (idn, N) in enumerate(ranges)
        for k in 1:n_trial
            values = compute(S, n_iter=N, print_step=-1)
            vec_values_x = Sb.(values[:, 2])
            results[idn, k] = mean(vec_values_x)
        end
    end

    # plot
    f = plot(size=(600, 400), margin=2Plots.cm, ylims=(0.10, 0.16))
    plot!(f, ranges, mean(results, dims=2), ribbon=std(results, dims=2), fillalpha=0.5, label=nothing)
    savefig("chapter5/fig5.4.png")
end

"""
Reweight
"""
function fig55(; n_trial=100)
    S(xy; α=0) = 0.5 * (xy[1]^2 + (xy[2] - α)^2 + xy[1] * (xy[2] - α))
    Sb(y) = (y <= 2) ? 0 : (y^2) / 2

    # re-weighting functions
    α1, α2, α3 = 0, 1.5, 3.0
    S1(xy) = S(xy; α=α1)
    S2(xy) = S(xy; α=α2)
    S3(xy) = S(xy; α=α3)

    ranges = 1000:2000:(2*10^5)
    results = zeros(Float64, length(ranges), n_trial)
    for (idn, N) in enumerate(ranges)
        """
        <Sbaseball(y)>
        = <exp(-Δ2,1)> α1
          × <exp(-Δ3,2)> α2
          × <exp(-Δ1,3) Sbaseball(y)> α3
        """
        for k in 1:n_trial
            values = compute(S, n_iter=N, print_step=-1)
            values1 = compute(S1, n_iter=N, print_step=-1)
            values2 = compute(S2, n_iter=N, print_step=-1)
            values3 = compute(S3, n_iter=N, print_step=-1)
            Δ21 = values2 .- values1
            Δ32 = values3 .- values2
            Δ13 = values1 .- values3
            results[idn, k] = mean(Δ21[:, 2]) * mean(Δ32[:, 2]) * mean(Δ13[:, 2]) * mean(Sb.(values[:, 2]))
        end
    end

    # plot
    f = plot(size=(600, 400), margin=2Plots.cm, ylims=(0.10, 0.16))
    plot!(f, ranges, mean(results, dims=2), ribbon=std(results, dims=2), fillalpha=0.5, label=nothing)
    savefig("chapter5/fig5.5.png")
end