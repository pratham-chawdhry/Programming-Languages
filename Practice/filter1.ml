let p x = if x mod 3 = 0 then true else false

let rec filter p lst = 
    match lst with 
    | [] -> []
    | x::xs -> 
        if p x then x :: filter p xs
        else filter p xs 

let rec print lst = 
    match lst with 
    | [] -> ()
    | h :: t -> 
        print_int h;
        print_string " ";
        print t

let main() = 
    let lst = [1; 2; 3; 4; 5; 6] in
    let result = filter p lst in
    print result

let _ = main()
filtL