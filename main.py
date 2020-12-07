import tkinter as tk
import yaml
from tkinter import messagebox
import fileinput
from pyswip import Prolog

QUESTIONS_FILE = 'questions.yaml'
MOTORCYCLE_FILE = 'motorcycles.yaml'
OUTPUT_FILE = 'form.txt'
knowledge_base_file = r'motorcycle_knowledge_base.pl'


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
        self.optionA_key = ""
        self.optionB_key = ""
        self.optionC_key = ""
        self.optionD_key = ""
        self.optionA = tk.IntVar()
        self.optionB = tk.IntVar()
        self.optionC = tk.IntVar()
        self.optionD = tk.IntVar()
        self.key = ""
        self.question = tk.StringVar()
        self.file = open(QUESTIONS_FILE, "r")
        self.motorcycles = open(MOTORCYCLE_FILE, 'r')
        self.questions = yaml.load(self.file, Loader=yaml.FullLoader)['questions']
        self.questions_iter = iter(self.questions)
        open(OUTPUT_FILE, 'w').close()
        top = self.winfo_toplevel()
        self.quitButton = tk.Button(self, text='Quit', command=self.confirm_quit)
        self.nextButton = tk.Button(self, text='Next', command=lambda: self.load_question())

        self.radioButtonA = tk.Checkbutton(self,
                                           textvariable=self.optionA,
                                           variable=self.varA,
                                           bg='black', fg='white', activebackground='black', activeforeground='white',selectcolor="black")
        self.radioButtonB = tk.Checkbutton(self,
                                           textvariable=self.optionB,
                                           variable=self.varB,
                                           bg='black', fg='white', activebackground='black', activeforeground='white',selectcolor="black")
        self.radioButtonC = tk.Checkbutton(self,
                                           textvariable=self.optionC,
                                           variable=self.varC,
                                           bg='black', fg='white', activebackground='black', activeforeground='white',selectcolor="black")
        self.radioButtonD = tk.Checkbutton(self,
                                           textvariable=self.optionD,
                                           variable=self.varD,
                                           bg='black', fg='white', activebackground='black', activeforeground='white',selectcolor="black")

        self.label_question = tk.Label(self, textvariable=self.question, justify='left')
        self.create_widgets(top)
        self.load_question()

    def new_game(self):
        self.load_question()

    def confirm_quit(self):
        choice = messagebox.askyesno('Quit Application', 'Are you sure ?')
        if choice:
            self.show_result()
        else:
            pass

    def save_answers(self):
        with open(OUTPUT_FILE, "a") as myfile:
            if self.varA.get() == 1:
                myfile.write(self.key + " " + str(self.optionA_key) + "\n")
            if self.varB.get() == 1:
                myfile.write(self.key + " " + str(self.optionB_key) + "\n")
            if self.varC.get() == 1:
                myfile.write(self.key + " " + str(self.optionC_key) + "\n")
            if self.varD.get() == 1:
                myfile.write(self.key + " " + str(self.optionD_key) + "\n")
        self.clear_boxes()

    def clear_boxes(self):
        self.varA.set(0)
        self.varB.set(0)
        self.varC.set(0)
        self.varD.set(0)

    def show_result(self):
        self.save_answers()
        with open(OUTPUT_FILE, 'r') as file:
            filedata = file.read()

        filedata = filedata.replace('nox', 'no')
        filedata = filedata.replace('offx', 'off')

        with open(OUTPUT_FILE, 'w') as file:
            file.write(filedata)

        prolog = Prolog()
        prolog.consult(knowledge_base_file)

        with open(OUTPUT_FILE, 'r') as f:
            for line in f.readlines():
                premise_type, value = line.split(' ')
                next(prolog.query(f'save({premise_type}, {value})'))

        print('State:')
        for x in prolog.query('ans(X, Y)'):
            print(x['X'], x['Y'])

        print('Suggestions:')
        predictions = ""
        motorcycles = yaml.load(self.motorcycles, Loader=yaml.FullLoader)['motorcycles']
        counter = 1
        for x in prolog.query('motorcycle(X)'):
            print(x)
            print(f' - {x["X"]}')
            predictions += str(counter) + '.' + motorcycles[x["X"]]['name'] + "\n\n"
            predictions += motorcycles[x["X"]]['info'] + "\n\n\n"
            counter += 1


        choice = messagebox.showinfo('Results', 'Your prediction is: \n ' + predictions)

        if choice:
            self.quit()
        else:
            self.quit()

    def load_question(self):
        self.save_answers()
        next_key = next(self.questions_iter, None)
        if next_key is None:
            self.show_result()
            return

        self.key = next_key

        self.question.set(self.questions[next_key]["question"])

        ans_iter = iter(self.questions[next_key]["answers"])
        ans_key = next(ans_iter)
        self.optionA_key = ans_key
        self.optionA.set(self.questions[next_key]["answers"][ans_key])

        ans_key = next(ans_iter)
        self.optionB_key = ans_key
        self.optionB.set(self.questions[next_key]["answers"][ans_key])

        ans_key = next(ans_iter)
        self.optionC_key = ans_key
        self.optionC.set(self.questions[next_key]["answers"][ans_key])

        ans_key = next(ans_iter, None)
        self.optionD_key = ans_key
        if ans_key is None:
            self.radioButtonD.grid_forget()
        else:
            self.radioButtonD.grid(column=3, row=4, sticky=tk.N + tk.S + tk.E + tk.W, columnspan=3)
            self.optionD.set(self.questions[next_key]["answers"][ans_key])

    def check_key(self, ans_key):
        if ans_key == 'nox':
            ans_key = 'no'
        elif ans_key == 'offx':
            ans_key = 'off'
        return ans_key

    def create_widgets(self, top):
        top.geometry("400x300")
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

        self.optionA.set('Hello A!')
        self.optionB.set('Hello B!')
        self.optionC.set('Hello C!')
        self.optionD.set('Hello D!')
        self.question.set('Demo Question')

        self.label_question.grid(column=3, row=0, columnspan=8)
        self.radioButtonA.grid(column=3, row=1, sticky=tk.N + tk.S + tk.W + tk.E, columnspan=3)
        self.radioButtonB.grid(column=3, row=2, sticky=tk.N + tk.S + tk.W + tk.E, columnspan=3)
        self.radioButtonC.grid(column=3, row=3, sticky=tk.N + tk.S + tk.E + tk.W, columnspan=3)
        self.radioButtonD.grid(column=3, row=4, sticky=tk.N + tk.S + tk.E + tk.W, columnspan=3)

        self.quitButton.grid(column=4, row=5, sticky='w')
        self.nextButton.grid(column=3, row=5, sticky='s')


if __name__ == "__main__":
    main()
