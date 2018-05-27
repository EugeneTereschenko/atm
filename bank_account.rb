class BankAccount
    attr_accessor :pin, :name, :password, :balance, :fileBalance
    @your_account = []
    
    def initialize(fileBalance)
        self.fileBalance = fileBalance
        if File.exist?(fileBalance)
            @your_account = YAML.load_file(fileBalance)
        end
        puts "Welcome to the Bank."
    end
    
    def save
        File.open(self.fileBalance, "w") do |file|
            file.write(@your_account.to_yaml)
        end
    end
    
    def count_max_sum
        maxsum = 0
        @your_account["banknotes"].each do |nominal, count|
            maxsum = maxsum + nominal.to_i * count.to_i
        end
        return maxsum
    end
    
    
    def withdraw
        puts "Enter Amount You Wish to Withdraw:"
        sum = $stdin.gets.chomp.to_i
        currentsum = sum
        maxSum = count_max_sum
        
        if sum > self.balance
            puts "ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT:"
            return
        end

        if  sum > maxSum 
            puts "ERROR: THE MAXIMUM AMOUNT AVAILABLE IN THIS ATM IS ₴" + maxSum.to_s + ". PLEASE ENTER A DIFFERENT AMOUNT:"
            return
        end    
        
        banknotesForIssue = {}
        
        @your_account["banknotes"].each do |nominal, count|
            if nominal > sum
                next
            end
            if count == 0
                next
            end
            numberOfbanknotes = sum / nominal
            if count < numberOfbanknotes
                banknotesForIssue.update({nominal.to_s=>count})
                sum = sum - nominal * count
            else
                banknotesForIssue.update({nominal.to_s=>numberOfbanknotes})
                sum = sum - nominal * numberOfbanknotes
            end
            
        end
        
        if  sum > 0
            puts "ERROR: THE AMOUNT YOU REQUESTED CANNOT BE COMPOSED FROM BILLS AVAILABLE IN THIS ATM. PLEASE ENTER A DIFFERENT AMOUNT:"
            return
        end
        
        banknotesForIssue.each do |nominal, count|
            newcount = @your_account["banknotes"][nominal.to_i].to_i - count
            @your_account["banknotes"][nominal.to_i] = newcount
        end
        self.balance = self.balance - currentsum
        puts "\nYour Current Balance is ₴" + self.balance.to_s + "\n"
        save
    end
    
    def choose_banknotes
        if self.balance && self.name && self.password && self.pin
            puts "\nHello," + self.name.to_s + "!\n"
        end
        loop do
            if self.balance && self.name && self.password && self.pin
                puts "\nPlease Choose From the Following Options:"
                puts "1. Display Balance"
                puts "2. Withdraw"
                puts "3. Log Out"
                your_choose = $stdin.gets.chomp.to_s
                    case your_choose.to_i
                        when 1 then puts "\nYour Current Balance is ₴" + self.balance.to_s + "\n"
                        when 2 then withdraw
                        when 3 then logout
                    end
            end
        end
    end
                            
    def logout
        puts "\n" + self.name + ", Thank You For Using Our ATM. Good-Bye!"
        self.pin = nil
        self.name = nil
        self.password = nil
        self.balance = nil
        run
    end
                            
    def run
        puts "\n"
        loop do
            puts "Please Enter Your Account Number:"
            self.pin = $stdin.gets.chomp.to_s 
            @your_account["accounts"].each do |key, value|
                if self.pin.to_i == key
                    puts "Enter Your Name:"
                    self.name = $stdin.gets.chomp.to_s
                        if value["name"].eql?(self.name)
                            puts "Enter Your Password:"
                            self.password = $stdin.gets.chomp.to_s
                        end
                        if value["password"].eql?(self.password)
                            self.balance = value["balance"]
                        end   
                end
            end              
            if self.balance && self.name && self.password && self.pin
                choose_banknotes
                break
            end
        end
    end
    
end