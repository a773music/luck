probs = [1,.3,1,.2]

while self.running:
    if probs[int(t.sub(.25)) % len(probs)] > random.random():
        self.on();
    t.wait(.25)

