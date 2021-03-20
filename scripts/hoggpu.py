import torch
import sys

args = sys.argv
print(args)
device_id = int(args[1] if len(args) > 1 else 0)

x = torch.randn(1,1, device=device_id)
print(f"Hogging {device_id}")
breakpoint()
