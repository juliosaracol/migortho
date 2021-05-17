#ifndef ITER_SLICE_HPP_
#define ITER_SLICE_HPP_

#include "internal/iterator_wrapper.hpp"
#include "internal/iterbase.hpp"

#include <iterator>
#include <type_traits>

namespace iter {
  namespace impl {
    template <typename Container, typename DifferenceType>
    class Sliced;

    struct SliceFn;
  }
}

template <typename Container, typename DifferenceType>
class iter::impl::Sliced {
 private:
  Container container_;
  DifferenceType start_;
  DifferenceType stop_;
  DifferenceType step_;

  friend SliceFn;

  Sliced(Container&& container, DifferenceType start, DifferenceType stop,
      DifferenceType step)
      : container_(std::forward<Container>(container)),
        start_{start < stop && step > 0 ? start : stop},
        stop_{stop},
        step_{step} {}

 public:
  Sliced(Sliced&&) = default;
  class Iterator : public std::iterator<std::input_iterator_tag,
                       iterator_traits_deref<Container>> {
   private:
    IteratorWrapper<Container> sub_iter_;
    IteratorWrapper<Container> sub_end_;
    DifferenceType current_;
    DifferenceType stop_;
    DifferenceType step_;

   public:
    Iterator(IteratorWrapper<Container>&& sub_iter,
        IteratorWrapper<Container>&& sub_end, DifferenceType start,
        DifferenceType stop, DifferenceType step)
        : sub_iter_{std::move(sub_iter)},
          sub_end_{std::move(sub_end)},
          current_{start},
          stop_{stop},
          step_{step} {}

    iterator_deref<Container> operator*() {
      return *sub_iter_;
    }

    iterator_arrow<Container> operator->() {
      return apply_arrow(sub_iter_);
    }

    Iterator& operator++() {
      dumb_advance(sub_iter_, sub_end_, step_);
      current_ += step_;
      if (stop_ < current_) {
        current_ = stop_;
      }
      return *this;
    }

    Iterator operator++(int) {
      auto ret = *this;
      ++*this;
      return ret;
    }

    bool operator!=(const Iterator& other) const {
      return sub_iter_ != other.sub_iter_ && current_ != other.current_;
    }

    bool operator==(const Iterator& other) const {
      return !(*this != other);
    }
  };

  Iterator begin() {
    auto it = std::begin(container_);
    dumb_advance(it, std::end(container_), start_);
    return {std::move(it), std::end(container_), start_, stop_, step_};
  }

  Iterator end() {
    return {std::end(container_), std::end(container_), stop_, stop_, step_};
  }
};

struct iter::impl::SliceFn {
 private:
  template <typename DifferenceType>
  class FnPartial : public Pipeable<FnPartial<DifferenceType>> {
   public:
    template <typename Container>
    Sliced<Container, DifferenceType> operator()(Container&& container) const {
      return {std::forward<Container>(container), start_, stop_, step_};
    }

   private:
    friend SliceFn;
    constexpr FnPartial(
        DifferenceType start, DifferenceType stop, DifferenceType step) noexcept
        : start_{start}, stop_{stop}, step_{step} {}
    DifferenceType start_;
    DifferenceType stop_;
    DifferenceType step_;
  };

 public:
  template <typename Container, typename DifferenceType,
      typename = std::enable_if_t<is_iterable<Container>>>
  Sliced<Container, DifferenceType> operator()(Container&& container,
      DifferenceType start, DifferenceType stop,
      DifferenceType step = 1) const {
    return {std::forward<Container>(container), start, stop, step};
  }

  // only given the end, assume step_ is 1 and begin is 0
  template <typename Container, typename DifferenceType,
      typename = std::enable_if_t<is_iterable<Container>>>
  iter::impl::Sliced<Container, DifferenceType> operator()(
      Container&& container, DifferenceType stop) const {
    return {std::forward<Container>(container), 0, stop, 1};
  }

  template <typename DifferenceType,
      typename = std::enable_if_t<!is_iterable<DifferenceType>>>
  constexpr FnPartial<DifferenceType> operator()(DifferenceType stop) const
      noexcept {
    return {0, stop, 1};
  }

  template <typename DifferenceType,
      typename = std::enable_if_t<!is_iterable<DifferenceType>>>
  constexpr FnPartial<DifferenceType> operator()(DifferenceType start,
      DifferenceType stop, DifferenceType step = 1) const noexcept {
    return {start, stop, step};
  }
};

namespace iter {
  constexpr impl::SliceFn slice{};
}

#endif
