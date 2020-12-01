import tkinter as tk
import yaml
from tkinter import messagebox
import fileinput
from pyswip import Prolog

QUESTIONS_FILE = 'questions.yaml'
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
        self.questions = yaml.load(self.file, Loader=yaml.FullLoader)['questions']
        self.questions_iter = iter(self.questions)
        open(OUTPUT_FILE, 'w').close()
        top = self.winfo_toplevel()
        self.quitButton = tk.Button(self, text='Quit', command=self.confirm_quit)
        self.nextButton = tk.Button(self, text='Next', command=lambda: self.load_question())

        self.radioButtonA = tk.Checkbutton(self,
                                           textvariable=self.optionA,
                                           variable=self.varA,
                                           bg='#45484c',
                                           fg='#e5e5e5')
        self.radioButtonB = tk.Checkbutton(self,
                                           textvariable=self.optionB,
                                           variable=self.varB,
                                           bg='#45484c', fg='#e5e5e5')
        self.radioButtonC = tk.Checkbutton(self,
                                           textvariable=self.optionC,
                                           variable=self.varC,
                                           bg='#45484c', fg='#e5e5e5')
        self.radioButtonD = tk.Checkbutton(self,
                                           textvariable=self.optionD,
                                           variable=self.varD,
                                           bg='#45484c', fg='#e5e5e5')

        self.label_question = tk.Label(self, textvariable=self.question)
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
        for x in prolog.query('motorcycle(X)'):
            print(x)
            print(f' - {x["X"]}')
            predictions += x["X"] + "\n"

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
            self.radioButtonD.grid(column=2, row=7, sticky=tk.N + tk.S + tk.E + tk.W)
            self.optionD.set(self.questions[next_key]["answers"][ans_key])

    def check_key(self, ans_key):
        if ans_key == 'nox':
            ans_key = 'no'
        elif ans_key == 'offx':
            ans_key = 'off'
        return ans_key

    def create_widgets(self, top):
        top.geometry("800x600")
        top.resizable(True, True)
        top.grid_columnconfigure(0, weight=1)
        top.grid_columnconfigure(9, weight=1)
        top.grid_rowconfigure(0, weight=1)
        top.grid_rowconfigure(9, weight=1)

        self.optionA.set('Hello A!')
        self.optionB.set('Hello B!')
        self.optionC.set('Hello C!')
        self.optionD.set('Hello D!')
        self.question.set('Demo Question')

        self.label_question.grid(column=3, row=1, columnspan=4)

        self.radioButtonA.grid(column=2, row=4, sticky=tk.N + tk.S + tk.W + tk.E)
        self.radioButtonB.grid(column=2, row=5, sticky=tk.N + tk.S + tk.W + tk.E)
        self.radioButtonC.grid(column=2, row=6, sticky=tk.N + tk.S + tk.E + tk.W)
        self.radioButtonD.grid(column=2, row=7, sticky=tk.N + tk.S + tk.E + tk.W)

        self.quitButton.grid(column=4, row=9)
        self.nextButton.grid(column=3, row=9)
        top.geometry("800x600")


if __name__ == "__main__":
    main()
