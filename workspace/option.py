import torch

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

class dict_options:
    opt = {}
    opt["device"] =device
    opt["report_host"] = "http://localhost:7890"

    def call_default(self):
        return self.opt