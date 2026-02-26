let f x = 2*x

let rec map f lst = 
    match lst with 
    | [] -> []
    | x :: xs -> f x :: map f xs

let main() = 
    let lst = [1; 2; 3; 4] in 
    let result = map f lst in
    let str =
        String.concat " "
        (List.map string_of_int result)
    in
    print_endline str

let _ = main()