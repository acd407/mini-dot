function ssho --wraps ssh --description "Ssh without check host key"
    ssh -o StrictHostKeyChecking=no $argv
end
