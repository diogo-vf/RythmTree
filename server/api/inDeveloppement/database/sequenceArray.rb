class SequenceArray < Array      
    public

    def add(sequence)        
        self.push(Sequence) if sequence <= Sequence
    end
end