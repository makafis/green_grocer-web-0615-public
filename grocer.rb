require 'pry'
def consolidate_cart(cart:[])
  return_cart = {}
    cart.each do |variable|
        variable.each do |item,value|
            if return_cart[item]
              return_cart[item][:count] += 1
            else
             return_cart[item] = value.merge(:count =>1)
            end
        end
    end
  return_cart
end

def apply_coupons(cart:[], coupons:[])
    coupons.each do |coupon_hash|
      if cart.keys.include?(coupon_hash[:item]) && cart[coupon_hash[:item]][:count] >= coupon_hash[:num]
        discount_q = cart[coupon_hash[:item]][:count] / coupon_hash[:num]
        cart[coupon_hash[:item]][:count] = cart[coupon_hash[:item]][:count]-coupon_hash[:num] * discount_q
        cart["#{coupon_hash[:item].upcase} W/COUPON"] = {:price => coupon_hash[:cost], :clearance => cart[coupon_hash[:item]][:clearance], :count => discount_q}
      end
    end
    cart
end

def apply_clearance(cart:[])

  clearance_hash = cart.dup
      clearance_hash.each do |item, item_hash|         
        if item_hash[:clearance]
          clearance_hash[item][:price] = cart[item][:price]*0.8
          clearance_hash[item][:price] = clearance_hash[item][:price].round(1)
        end

      end

     clearance_hash
end

def checkout(cart: [], coupons: [])
    sum = 0
    consolidate_cart = consolidate_cart(cart: cart)
    consolidate_cart = apply_coupons(cart: consolidate_cart, coupons: coupons)
    consolidate_cart = apply_clearance(cart: consolidate_cart)
    consolidate_cart.each do |item_name, cart_summary|
      sum += (cart_summary[:price]*cart_summary[:count].to_f)
    end

    if sum > 100
        sum = sum*0.9
    end
sum
end