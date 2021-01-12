import tkinter as tk
import yaml
from tkinter import messagebox
import fileinput
import pysmile
import pysmile_license

NETWORK_FILE = 'mes.xdsl'


def main():
    app = Application()
    app.master.title('MotorcycleExpertSystem')
    app.mainloop()


class Application(tk.Frame):

    def __init__(self, master=None):
        tk.Frame.__init__(self, master)
        self.flag = 0
        self.grid()
        self.varA = tk.IntVar()
        self.varB = tk.IntVar()
        self.varC = tk.IntVar()
        self.varD = tk.IntVar()
        self.key = ""
        self.question = tk.StringVar()
        top = self.winfo_toplevel()
        self.nextButton = tk.Button(self, text='Show results', command=lambda: self.show_result())

        self.radioButtonA = tk.Scale(self,
                                           label="travel",
                                           variable=self.varA,
                                           bg='black', fg='white', from_=0, to=10, orient=tk.HORIZONTAL)
        self.radioButtonB = tk.Scale(self,
                                           label="have fun",
                                           variable=self.varB,
                                           bg='black', fg='white', from_=0, to=10, orient=tk.HORIZONTAL)
        self.radioButtonC = tk.Scale(self,
                                           label="commute",
                                           variable=self.varC,
                                           bg='black', fg='white', from_=0, to=10, orient=tk.HORIZONTAL)
        self.radioButtonD = tk.Scale(self,
                                           label="relax",
                                           variable=self.varD,
                                           bg='black', fg='white', from_=0, to=10, orient=tk.HORIZONTAL)

        self.label_question = tk.Label(self, textvariable=self.question, justify='left')
        self.create_widgets(top)
        self.question.set("Check how much you want to do these things with your motorcycle:")


    def clear_boxes(self):
        self.varA.set(0)
        self.varB.set(0)
        self.varC.set(0)
        self.varD.set(0)

    def show_result(self):
        net = pysmile.Network()
        motorcycles = ['adv', 'moped', 'cruiser', 'sport', 'touring', 'naked', 'power_cruiser', 'sport_touring']
        net.read_file(NETWORK_FILE)

        net.set_virtual_evidence("travel", [self.varA.get()/10, 1-self.varA.get()/10])
        net.set_virtual_evidence("fun", [self.varB.get()/10, 1-self.varB.get()/10])
        net.set_virtual_evidence("commute", [self.varC.get()/10, 1-self.varC.get()/10])
        net.set_virtual_evidence("relax", [self.varD.get()/10, 1-self.varD.get()/10])

        net.update_beliefs()
        probs = dict()
        for item in motorcycles:
            probs[item] = net.get_node_value(item)

        predictions = ""
        for item in sorted(probs.items(), key=lambda x: x[1][0], reverse=True):
            print(item)
            predictions += item[0] + ": " + str(round(item[1][0], 2)) + "\n"
        choice = messagebox.showinfo('Results', 'Chances you will like those motorcycle types: \n' + predictions)

        if choice:
            self.quit()
        else:
            self.quit()

    def create_widgets(self, top):
        top.geometry("800x600")
        top.resizable(True, True)

        top.grid_columnconfigure(0, weight=1)
        top.grid_columnconfigure(1, weight=1)
        top.grid_columnconfigure(2, weight=1)
        top.grid_columnconfigure(3, weight=1)
        top.grid_columnconfigure(4, weight=1)
        top.grid_columnconfigure(5, weight=1)
        top.grid_rowconfigure(0, weight=1)
        top.grid_rowconfigure(1, weight=1)
        top.grid_rowconfigure(2, weight=1)
        top.grid_rowconfigure(3, weight=1)
        top.grid_rowconfigure(4, weight=1)
        top.grid_rowconfigure(5, weight=1)

        self.question.set('Demo Question')

        self.label_question.grid(column=3, row=0, columnspan=8)
        self.radioButtonA.grid(column=3, row=1, sticky=tk.N + tk.S + tk.W + tk.E, columnspan=3)
        self.radioButtonB.grid(column=3, row=2, sticky=tk.N + tk.S + tk.W + tk.E, columnspan=3)
        self.radioButtonC.grid(column=3, row=3, sticky=tk.N + tk.S + tk.E + tk.W, columnspan=3)
        self.radioButtonD.grid(column=3, row=4, sticky=tk.N + tk.S + tk.E + tk.W, columnspan=3)
        self.nextButton.grid(column=4, row=13, sticky='s')


if __name__ == "__main__":
    main()
