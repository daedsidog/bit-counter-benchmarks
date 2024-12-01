#include <iostream>

namespace ck_lli_cpp {  
  
  template <typename T, typename V>
  struct cons {
    T car;
    V cdr;
    cons(T car) : car(car), cdr(nullptr) {}
    cons(T car, V cdr) : car(car), cdr(cdr) {}
  };
  
  template<typename T, typename V>
  std::ostream& operator<<(std::ostream& os, const cons<T, V>& c) {
    os << "(" << c.car;
    auto current = &c.cdr;
    while (true) {
        if (current == nullptr) {
          break;
        }
        else if (auto next_cons = dynamic_cast<const cons<typename V::car_type,
                                                          typename V::cdr_type>*>(current)) {
          os << " " << next_cons->car;
          current = &next_cons->cdr;
        }
        else {
          os << " . " << *current;
          break;
        }
    }
    os << ")";
    return os;
  }
  
  std::ostream& operator<<(std::ostream& os, std::nullptr_t) {
    return os << "NIL";
  }  
  
  template <typename T0, typename T1>
  auto SB_IMPL_SUB272_XSUBTRACT(T0 ARG_A, T1 ARG_B) {
    return (ARG_B - ARG_A);
  }
}

int main() {
  {  
    auto ARG_LONGEST_BITS = []() {
      return 0;
    }();
    auto ARG_CURRENT_BITS = []() {
      return 0;
    }();
    /* Ignored operator DECLARE from COMMON-LISP */
    [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS]() {
      {  
        auto ARG_G257 = [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS]() {
          return nullptr;
        }();
        {  
          auto ARG_CHAR = [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS, &ARG_G257]() {
            return 0;
          }();
          /* Ignored operator DECLARE from COMMON-LISP */
          {
            ARG_CHAR = std::cin.get();
          }
          LABEL_G259260:
          if (ARG_CHAR == std::char_traits<char>::eof()) {
            goto LABEL_END_LOOP261;
          }
          [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS, &ARG_G257, &ARG_CHAR]() {
            {  
              auto ARG_G267 = [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS, &ARG_G257, &ARG_CHAR]() {
                return nullptr;
              }();
              {  
                auto ARG_G263 = [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS, &ARG_G257, &ARG_CHAR, &ARG_G267]() {
                  return 7;
                }();
                auto ARG_G264 = [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS, &ARG_G257, &ARG_CHAR, &ARG_G267]() {
                  return 0;
                }();
                auto ARG_G265 = [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS, &ARG_G257, &ARG_CHAR, &ARG_G267]() {
                  return 1;
                }();
                {  
                  auto ARG_G266 = [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS, &ARG_G257, &ARG_CHAR, &ARG_G267, &ARG_G263, &ARG_G264, &ARG_G265]() {
                    return ARG_G263;
                  }();
                  auto ARG_I = [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS, &ARG_G257, &ARG_CHAR, &ARG_G267, &ARG_G263, &ARG_G264, &ARG_G265]() {
                    return ARG_G263;
                  }();
                  /* Ignored operator DECLARE from COMMON-LISP */
                  if (!(ARG_G264 <= ARG_G266)) {
                    goto LABEL_END_LOOP271;
                  }
                  ARG_G266 = ck_lli_cpp::SB_IMPL_SUB272_XSUBTRACT(ARG_G265, ARG_G266);
                  LABEL_G269270:
                  if (0 == [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS, &ARG_G257, &ARG_CHAR, &ARG_G267, &ARG_G263, &ARG_G264, &ARG_G265, &ARG_G266, &ARG_I]() {
                    auto cons = ck_lli_cpp::cons(1, ARG_I);
                    return (ARG_CHAR >> cons.cdr) & ((1 << cons.car) - 1);
                  }()) {
                    {
                      if (ARG_CURRENT_BITS > ARG_LONGEST_BITS) {
                        ARG_LONGEST_BITS = ARG_CURRENT_BITS;
                      }
                      ARG_CURRENT_BITS = 0;
                    }
                  }
                  else {
                    ARG_CURRENT_BITS = (1 + ARG_CURRENT_BITS);
                  }
                  if (!(ARG_G264 <= ARG_G266)) {
                    goto LABEL_END_LOOP271;
                  }
                  ARG_I = ARG_G266;
                  ARG_G266 = ck_lli_cpp::SB_IMPL_SUB272_XSUBTRACT(ARG_G265, ARG_G266);
                  goto LABEL_G269270;
                  LABEL_END_LOOP271:
                  return ARG_G267;
                }
              }
            }
          }();
          {  
            ARG_CHAR = std::cin.get();
          }
          goto LABEL_G259260;
          LABEL_END_LOOP261:
          return ARG_G257;
        }
      }
    }();
    if (ARG_CURRENT_BITS > ARG_LONGEST_BITS) {
      ARG_LONGEST_BITS = ARG_CURRENT_BITS;
    }
    [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS]() {
      auto ARG_G274 = ARG_LONGEST_BITS;
      std::cout << ARG_G274;
      return ARG_G274;
    }();
    [&ARG_LONGEST_BITS, &ARG_CURRENT_BITS]() {
      std::cout << std::endl;
      return nullptr;
    }();
    return 0;
  }
}
