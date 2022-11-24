process(entree)
begin
    case cur_state is 
    when Etat0 =>
    if entree = '!' then 
    next_state <= Etat1;
    else
        next_state <= 