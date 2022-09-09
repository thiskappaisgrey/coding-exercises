#[derive(Debug, PartialEq, Eq)]
pub enum Comparison {
    Equal,
    Sublist,
    Superlist,
    Unequal,
}

pub fn sublist<T: PartialEq>(_first_list: &[T], _second_list: &[T]) -> Comparison {
    // unimplemented!("Determine if the first list is equal to, sublist of, superlist of or unequal to the second list.");
    use Comparison::*;
    if _first_list == _second_list {
	return Equal;
    }
    if _first_list.is_empty() {
	return Sublist
    }
    if _second_list.is_empty() {
	return Superlist
    }
    if is_sublist_of (_first_list, _second_list) {
	return Sublist;
    }
    if is_sublist_of (_second_list, _first_list) {
	return Superlist;
    }
    return Unequal;
    
}
// check if first list is sublist of second
fn is_sublist_of<T: PartialEq>(_first_list: &[T], _second_list: &[T]) -> bool {
    // for list in
    // let iter = _second_list.windows(_first_list.len());
    // for list in iter {
    // 	if list == _first_list {
    // 	    return true;
    // 	}
    // }
    // false

    _second_list.windows(_first_list.len()).any(|x| x == _first_list)
} 
