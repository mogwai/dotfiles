# Enable tab completion                                                         
import rlcompleter                                                              
import pdb                                                                      

class Config(pdb.DefaultConfig):
    def __init__(self):
        super().__init__()
        self.sticky_by_default = True
        self.complete = rlcompleter.Completer(locals()).complete


