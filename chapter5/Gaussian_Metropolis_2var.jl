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

        if i % print_step == 0
            println("$i $(xy[1]) $(xy[2]) $(n_accept/i)")
        end
    end
    values
end

function sample()
    S(xy) = 0.5 * (xy[1] * xy[1] + xy[2] * xy[2] + xy[1] * xy[2])
    
    N = 10 ^ 6
    values = compute(S, n_iter=N, print_step=10^5)

    # 10ステップ毎だけのサンプル
    step = 100
    indices = 1:step:N
    f = plot(size=(400, 400))
    scatter!(f, values[indices, 1], values[indices, 2], marker=:cross, label="")
    plot!(f, -3:0.01:3, 3:-0.01:-3, lw=0.5, color=:red, label="")
    savefig(f, "chapter5/fig5.1.png")
end