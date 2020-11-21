import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
# Graficar exactitud vs orden utilizado
# Probar para ordenes 2, 4, 6 con delta t y delta t/2
# Hacer 5 corridas y hacer un grafico con barra de error.
# ESTO SE HACE CON LO DE JIM


# Graficar la exactitud del metodo de cuarto orden respecto del delta t utilizado
# Probar con orden 4 para 4 delta t distinto.
# Hacer 10 corridas y hacer un grafico con barra de error
# ESTO SE HACE CON LO DE JIME



# Graficar el speed up para orden 2, 4, 6 y luego para orden 50, 60, 80.
def speed_up_plot():
    df = pd.read_csv("./data/metrics.csv", delimiter="\t")
    print(df.head())

    orders = np.array(df['order'].drop_duplicates())
    parallels = df.loc[df['parallel'] == True]
    series = df.loc[df['parallel'] == False]

    speed_ups = []

    for order in orders:
        speed_ups.append( \
            np.array(series.loc[series['order'] == order]['time'])/np.array(parallels.loc[parallels['order'] == order]['time']))

    means = []
    stds = []

    for sp_up in speed_ups:
        means.append(np.mean(sp_up))
        stds.append(np.std(sp_up))

    plt.xlabel("orden")
    plt.ylabel("speed up")
    plt.xticks(orders, labels=orders)
    plt.errorbar(orders, means, stds, linestyle='None', solid_capstyle='projecting', capsize=5, marker='o')
    plt.savefig("speed_up_orders_2_4_6.png")

def ideal_times_vs_parallel():
    df = pd.read_csv("./data/metrics.csv", delimiter="\t")
    print(df.head())

    orders = np.array(df['order'].drop_duplicates())
    parallels = df.loc[df['parallel'] == True]
    series = df.loc[df['parallel'] == False]

    ideals = []
    reals = []

    for order in orders:
        ideals.append( \
            np.array(series.loc[series['order'] == order]['time'])/order)
        reals.append(
            np.array(parallels.loc[parallels['order'] == order]['time'])
        )

    ideals_avg = []
    reals_avg = []

    for i in range(len(orders)):
        ideals_avg.append(np.mean(ideals[i]))
        reals_avg.append(np.mean(reals[i]))

    ax = plt.gca()
    ax.set_yscale('log')
    plt.xlabel("orden")
    plt.ylabel("time [s]")
    plt.xticks(orders, labels=orders)
    ideals = plt.scatter(orders, ideals_avg)
    reals = plt.scatter(orders, reals_avg)
    plt.legend((ideals, reals), ("Tiempo paralelización ideal", "Tiempo real"))
    plt.savefig("tiempo_ideal_vs_tiempo_real.png")

accuracy_vs_time()