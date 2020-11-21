import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Graficar la exactitud del metodo de cuarto orden respecto del delta t utilizado
# Probar con orden 4 para 4 delta t distinto.
def accuracy_vs_time():
    orders = [2, 4, 6]
    xs = []
    times = []
    complete_times = True

    plt.xlabel("tiempo [s]")
    plt.ylabel("error")
    for order in orders:
        df = pd.read_csv(f"./data/errors_{order}_0.0001.csv", delimiter="\t")
        if complete_times:
            times = np.array(df['delta_t'])
            complete_times = False
        errors = np.array(df['error'])
        xs.append(plt.scatter(times, errors))

    plt.legend((xs[0], xs[1], xs[2]), ("Método Orden 2", "Método Orden 4", "Método Orden 6"))
    plt.savefig(f"./results/accuracy_vs_time_2_4_6_0.0001.png")
    plt.clf()

def accuracy_vs_time_different_dt():
    deltas = ["0.0003", "0.0001", "0.00005", "0.00001"]
    xs = []

    plt.xlabel("tiempo [s]\n\nMétodo Orden 4")
    plt.ylabel("error")
    for delta in deltas:
        df = pd.read_csv(f"./data/errors_4_{delta}.csv", delimiter="\t")
        times = np.array(df['delta_t'])
        errors = np.array(df['error'])
        xs.append(plt.scatter(times, errors))

    plt.legend((xs[0], xs[1], xs[2], xs[3]), ("h 0.003", "h 0.001", "h 0.0005", "h 0.0001"))
    plt.savefig(f"./results/accuracy_vs_time_different_deltas.png")
    plt.clf()



def accuracy_strang_vs_order_2():
    df = pd.read_csv(f"./data/errors_2_0.0001.csv", delimiter="\t")
    times = np.array(df['delta_t'])
    errors = np.array(df['error'])
    s_df = pd.read_csv(f"./data/errors_strang_0.0001.csv", delimiter="\t")
    strang_errors = np.array(s_df['error'])

    plt.xlabel("tiempo [s]")
    plt.ylabel("error")
    order_two = plt.scatter(times, errors)
    strang = plt.scatter(times, strang_errors, linewidths=0)

    plt.legend((order_two, strang), ("Método Orden 2", "Método Strang"))
    plt.savefig(f"./results/accuracy_strang_vs_order_2_0.0001.png")
    plt.clf()

def infinity_norm_over_order():
    orders = [2, 4, 6]
    deltaT = 0.0001
    errors = []
    for order in orders:
        df: pd.DataFrame = pd.read_csv(f"./data/errors_{order}_{deltaT}.csv", delimiter="\t")
        print(df.head())
        tmp: np.ndarray = np.array(df['error'], dtype=np.float64)
        tmp = tmp.reshape(len(tmp))
        errors.append(np.linalg.norm(tmp, np.inf))

    plt.xlabel("orden")
    plt.ylabel("error")
    plt.xticks(orders, labels=orders)
    plt.scatter(orders, errors, marker='o')
    plt.savefig("data/inf_norm_order_2_4_6.png")
    plt.clf()


def strang_infinity_norm():
    deltaT = 0.0001
    errors = []

    df: pd.DataFrame = pd.read_csv(f"./data/errors_strang_{deltaT}.csv", delimiter="\t")
    print(df.head())
    tmp: np.ndarray = np.array(df['error'], dtype=np.float64)
    print(f"Infinity norm: {np.linalg.norm(tmp, np.inf)}")


# Graficar el speed up para orden 2, 4, 6 y luego para orden 50, 60, 80.
def speed_up_plot():
    df = pd.read_csv("./data/metrics.csv", delimiter="\t")

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
    plt.savefig("./results/speed_up_orders_2_4_6.png")
    plt.clf()


def ideal_times_vs_parallel():
    df = pd.read_csv("./data/metrics.csv", delimiter="\t")

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
    plt.savefig("./results/tiempo_ideal_vs_tiempo_real.png")
    plt.clf()


if __name__ == '__main__':
    #ideal_times_vs_parallel()
    #speed_up_plot()
    #accuracy_vs_time()
    #infinity_norm_over_order()
    #accuracy_strang_vs_order_2()
    #strang_infinity_norm()
    accuracy_vs_time_different_dt()