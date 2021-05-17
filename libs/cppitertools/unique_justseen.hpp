#ifndef ITER_UNIQUE_JUSTSEEN_HPP
#define ITER_UNIQUE_JUSTSEEN_HPP

#include "groupby.hpp"
#include "imap.hpp"

#include <iterator>
#include <utility>

namespace iter {
  namespace impl {
    struct UniqueJustseenFn : Pipeable<UniqueJustseenFn> {
      template <typename Container>
      auto operator()(Container&& container) const {
        // explicit return type in lambda so reference types are preserved
        return imap(
            [](auto&& group) -> impl::iterator_deref<Container> {
              return *std::begin(group.second);
            },
            groupby(std::forward<Container>(container)));
      }
    };
  }
  constexpr impl::UniqueJustseenFn unique_justseen{};
}

#endif
