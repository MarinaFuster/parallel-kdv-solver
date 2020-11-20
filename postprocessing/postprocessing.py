import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
# Graficar exactitud vs orden utilizado
# Probar para ordenes 2, 4, 6 con delta t y delta t/2
# Hacer 10 corridas y hacer un grafico con barra de error.
# ESTO SE HACE CON LO DE JIME


# Graficar la exactitud del metodo de cuarto orden respecto del delta t utilizado
# Probar con orden 4 para 4 delta t distinto.
# Hacer 10 corridas y hacer un grafico con barra de error
# ESTO SE HACE CON LO DE JIME


# Graficar la exactitud en funcion del tiempo
# tomar los archivos de exactitud para orden 2, 4, 6
# ESTO SE HACE CON LO DE JIME


# Graficar el speed up para orden 2, 4, 6 y luego para orden 50, 60, 80.
def speed_up_plot():
    df = pd.read_csv("metrics.csv", delimiter="\t")
    print(df.head())

    orders = np.array(df['order'].drop_duplicates())
    print(orders)

    parallels = df.loc[df['parallel'] == True]
    series = df.loc[df['parallel'] == False]

    print(parallels.head())
    print(series.head())

    speed_ups = []

    for order in orders:
        speed_ups.append( \
            np.array(series.loc[series['order'] == order]['time'])/np.array(parallels.loc[parallels['order'] == order]['time']))

    means = []
    stds = []

    for sp_up in speed_ups:
        means.append(np.mean(sp_up))
        stds.append(np.std(sp_up))

    print(len(speed_ups))
    print(len(means))
    print(len(stds))

    plt.errorbar(orders, means, stds, solid_capstyle='projecting', capsize=5)
    plt.show()

speed_up_plot()