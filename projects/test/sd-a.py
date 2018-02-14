probs = [0,0,0,0,1,0,0,.1]

while self.running:
    if probs[int(t.sub(.25)) % len(probs)] > random.random():
        self.on();
    t.wait(.25)

