using Distributions
using Plots
gr()


function fig52()
    xseq = -4.0:0.01:4.0

    Sp(x) = (2 .+ tanh.(x)) ./ 3
    Sb(x) = if x <= 2
        0
    else
        (x ^ 2) / 2
    end

    y1 = Sp(xseq)
    y2 = Sb.(xseq)

    f = plot(size=(500, 300))
    plot!(xseq, y1, ls=:dash, label="physics")
    plot!(xseq, y2, color=:red, label="baseball")
    savefig(f, "chapter5/fig5.2.png")
end