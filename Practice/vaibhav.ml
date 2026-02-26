let findmax lst = 
    let rec f lst acc = 
        match lst with 
        | [] -> acc
        | h :: t -> 
            let result = f t acc in
            if h > result then h
            else result
    in
    f lst 