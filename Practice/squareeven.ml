let rec printlist lst = 
    match lst with 
    | [] -> ();
    | h :: t -> 
        print_int h;
        print_string " ";
        printlist t

let main() = 
    let lst = [5; 4; 1; 4; 2; 3; 5; 22; 10; 9; 3; 5; 8; 1] in
    let result1 = List.fold_right (fun x acc -> if x mod 2 = 0 then acc + x*x else acc) lst 0 in 
    print_endline(string_of_int result1)
    
let _ = main()
