let rec printlist lst = 
    match lst with 
    | [] -> ();
    | h :: t -> 
        print_int h;
        print_string " ";
        printlist t

let main() = 
    let lst = [5; 4; 1; 4; 2; 3; 5; 22; 10; 9; 3; 5; 8; 1] in
    printlist(List.fold_right (fun x acc -> x::acc) lst [])
    
let _ = main()
