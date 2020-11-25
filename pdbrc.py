# Enable tab completion                                                         
import rlcompleter                                                              
import pdb                                                                      
pdb.Pdb.complete = rlcompleter.Completer(locals()).complete

class Config(pdb.DefaultConfig):
    def __init__(self):
        super().__init__()
        self.sticky_by_default = True

