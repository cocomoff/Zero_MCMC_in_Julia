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

    # println("$x $(n_accept/n_iter)")
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
    plot_i = exp10.(range(2, 7, length=100))
    seq_q1 = Float64[] # <x>
    seq_q2 = Float64[] # <x^2>

    for p in plot_i
        values_p = values[1:ceil(Int, p)]
        push!(seq_q1, mean(values_p))
        push!(seq_q2, mean(values_p .^ 2))
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


function fig44_45()
    S(x) = 0.5 * x * x
    n_iter = 10000
    step_size = 0.5
    x = 100.0
    n_accept = 0

    values = Float64[]
    # balanced_dist = Uniform(-1.0, 1.0)

    # main loop
    for i in 1:n_iter
        backup_x = x
        action_init = S(x)
        # x += rand(balanced_dist)
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

    # fig 4.4
    f = plot(size=(500, 300))
    plot!(f, values, color=:red, marker=:circle, label="")
    savefig(f, "chapter4/fig4.4.png")

    # fig 4.5
    f = plot(size=(500, 300))
    plot!(f, values[2000:3000], color=:red, marker=:circle, label="")
    savefig(f, "chapter4/fig4.5.png")
end

function fig46_47()
    """
    ジャックナイフ誤差
    """
end


function fig48(;n_step=100000)
    S(x) = 0.5 * x * x

    clistlist = [[0.5, 2.0, 4.0], [4.0, 8.0, 16.0]]
    plot_i = exp10.(range(2, 5, length=1000))
    for (idx, clist) in enumerate(clistlist)
        
        f = plot(size=(700, 500))
        
        for c in clist
            values = compute(S, n_iter=n_step, step_size=c);

            # compute <x^2> on log spaces
            seq_q2 = Float64[]
            for p in plot_i
                values_p = values[1:ceil(Int, p)]
                push!(seq_q2, mean(values_p .^ 2))
            end
            plot!(f, plot_i, seq_q2, lw=1.5, label="c=$c")
        end

        n = length(plot_i)
        plot!(f, plot_i, [1 for _ in 1:n], color=:blue, lw=1, label="")
    
        savefig(f, "chapter4/fig4.8_$(idx).png")
    end
end

function fig49(;n_bins=100, step_size=0.5)
    S(x) = -log(exp(-0.5*(x-3)^2) + exp(-0.5*(x+3)^2))
    list_hist = []
    n_steps = [10^3, 10^5, 10^7]
    for n_step in n_steps
        values = compute(S, n_iter=n_step, step_size=step_size);
        h = histogram(values, bins=n_bins, normalize=true, label="K=$(n_step)")
        push!(list_hist, h)
    end

    # f = plot(size=(1200, 300))
    h1, h2, h3 = list_hist
    f = plot(h1, h2, h3, layout=(1, 3), size=(1200, 300))
    savefig(f, "chapter4/fig4.9_s$(step_size).png")
end

function fig410(;n_bins=100, step_size=0.5)
    function S(x)
        if x >= 0
            0.5 * x * x
        elseif x >= -1
            sqrt(1 - x ^ 2)
        end
    end
    list_hist = []
    n_steps = [10^3, 10^5, 10^7]
    for n_step in n_steps
        x = 0.0
        n_accept = 0
        values = Float64[]
        for i in 1:n_step
            backup_x = x
            action_init = S(x)
            dx = rand()
            dx = (dx - 0.5) * step_size * 2;
            x += dx

            if x < -1
                x = backup_x
            else
                action_fin = S(x)
                if exp(action_init - action_fin) > rand()
                    n_accept += 1
                else
                    x = backup_x
                end
            end
            push!(values, x)
        end
            
        h = histogram(values, bins=n_bins, normalize=true, label="K=$(n_step)")
        push!(list_hist, h)
    end

    # f = plot(size=(1200, 300))
    h1, h2, h3 = list_hist
    f = plot(h1, h2, h3, layout=(1, 3), size=(1200, 300))
    savefig(f, "chapter4/fig4.10.png")
end
