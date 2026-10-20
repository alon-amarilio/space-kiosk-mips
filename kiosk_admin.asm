.data

menu_title:    .asciiz "\n=== Space Tourist Shuttle Kiosk ===\n"
item1:         .asciiz "1) Luna City - 75 credits "
item2:         .asciiz "2) Mars Dunes - 120 credits "
item3:         .asciiz "3) Europa Geysers - 90 credits "
item4:         .asciiz "4) Titan Lakes - 55 credits "
prompt_sel:    .asciiz "Enter choice: "
invalid_number: .asciiz "Invalid choice. Please try again: \n"
total_inserted: .asciiz "Total inserted: "
credits: .asciiz " credits\n"
prompt_pay:    .asciiz "Insert bill (1, 5, 10, 20): "
error_bill:    .asciiz "Invalid bill! Attemps left: "
error_cancel:  .asciiz "Transaction canceled due to repeated invalid input.\n"
msg_change:    .asciiz "Change: "
msg_dispensed:    .asciiz " dispensed!\n"
msg_done:      .asciiz "Tickets to "
seats:      .asciiz "(seats: "
close_para:      .asciiz ")\n"
com_mode:      .asciiz "0) Commander mode\n"
sold_out_msg:      .asciiz "(Sold Out)\n"
sold_out_dest:      .asciiz "Destination is sold out. Please choose another.\n"
enter_pin:      .asciiz "Enter commander PIN: "
access_granted:      .asciiz "Access granted.\n"
access_denied:      .asciiz "Access denied.\n"
msg_exit:      .asciiz "9) Exit kiosk\n"
newline:       .asciiz "\n"
set_seats:    .asciiz "Set seats for "
current:      .asciiz " (current: "
close_paren_col:  .asciiz "): "
exit_kiosk_msg: .asciiz "You have exited the kiosk, have a nice day!\n"
negative_qunt: .asciiz "Invalid quantity. Please enter a non-negative number.\n"

msg_updated:      .asciiz "Updated to "
err_inv_qty:      .asciiz "Invalid quantity. Please enter a non-negative number.\n"
msg_updates_done: .asciiz "\nAll updates complete. Returning to main menu...\n"

n_luna:    .asciiz "Luna City"
n_mars:    .asciiz "Mars Dunes"
n_europa:  .asciiz "Europa Geysers"
n_titan:   .asciiz "Titan Lakes"

names_array: .word n_luna, n_mars, n_europa, n_titan

prices:        .word 75, 120, 90, 55

avalible_seats:        .word 5,3,4,6

.text
.globl main

main:
	program_loop:
		jal DisplayMenu
	
		jal HandleSelection
		move $s0, $v0
		move $s2, $v1
	
		move $a0, $s0
		jal InsertCredits
	
		li $t0, -1
    	beq $v0, $t0, exit_program
	
		move $a0, $s0      
    	move $a1, $v0   
		jal CalculateChange
	
		la   $t0, names_array
    	add  $t0, $t0, $s2
    	lw   $a0, 0($t0)
    
    	la   $t1, avalible_seats
    	add  $a1, $t1, $s2
    
		jal DispenseTicket
		
		j program_loop
	 
DisplayMenu:
	addi $sp, $sp, -4
    sw   $ra, 0($sp)

    li $v0, 4
    la $a0, menu_title
    syscall
    
    li $v0, 4
    la $a0, item1
    syscall
    
    li  $t0, 0        
    mul $t0, $t0, 4
    la  $t1, avalible_seats
    add $t1, $t1, $t0
    lw  $t2, 0($t1)  
    
    beq $t2, 0, print_sold_out_1
    
    li $v0, 4
    la $a0, seats  
    syscall
    
    li $v0, 1
    move $a0, $t2    
    syscall
    
    li $v0, 4
    la $a0, close_para  
    syscall
    j end_item_1
    
print_sold_out_1:
    li $v0, 4
    la $a0, sold_out_msg
    syscall
    
end_item_1:

    li $v0, 4
    la $a0, item2
    syscall
    
    li  $t0, 1   
    mul $t0, $t0, 4
    la  $t1, avalible_seats
    add $t1, $t1, $t0
    lw  $t2, 0($t1)    
    
    beq $t2, 0, print_sold_out_2
    
    li $v0, 4
    la $a0, seats
    syscall
    
    li $v0, 1
    move $a0, $t2
    syscall
    
    li $v0, 4
    la $a0, close_para
    syscall
    j end_item_2
    
print_sold_out_2:
    li $v0, 4
    la $a0, sold_out_msg
    syscall
    
end_item_2:


    li $v0, 4
    la $a0, item3
    syscall
    
    li  $t0, 2      
    mul $t0, $t0, 4
    la  $t1, avalible_seats
    add $t1, $t1, $t0
    lw  $t2, 0($t1)     
    
    beq $t2, 0, print_sold_out_3
    
    li $v0, 4
    la $a0, seats
    syscall
    
    li $v0, 1
    move $a0, $t2
    syscall
    
    li $v0, 4
    la $a0, close_para
    syscall
    j end_item_3
    
print_sold_out_3:
    li $v0, 4
    la $a0, sold_out_msg
    syscall
    
end_item_3:


    li $v0, 4
    la $a0, item4
    syscall
    
    li  $t0, 3        
    mul $t0, $t0, 4
    la  $t1, avalible_seats
    add $t1, $t1, $t0
    lw  $t2, 0($t1)      
    
    beq $t2, 0, print_sold_out_4
    
    li $v0, 4
    la $a0, seats
    syscall
    
    li $v0, 1
    move $a0, $t2
    syscall
    
    li $v0, 4
    la $a0, close_para
    syscall
    j end_item_4
    
print_sold_out_4:
    li $v0, 4
    la $a0, sold_out_msg
    syscall
    
end_item_4:

    li $v0, 4
    la $a0, com_mode
    syscall
    la $a0, msg_exit
    syscall
    
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra
    
    
HandleSelection:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)

loop_selection:
    li $v0, 4
    la $a0, prompt_sel
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

	beq $t0, 0, commander_mode
	beq $t0, 9, exit_kiosk
	
    blt $t0, 1, invalid_choice  
    bgt $t0, 4, invalid_choice

	sub $t0, $t0, 1    
    mul $t0, $t0, 4
    
    move $v1, $t0
    la $t1, prices      
    add $t1, $t1, $t0   
    lw  $v0, 0($t1)
    
    la $t3, avalible_seats
    add $t3, $t3, $t0
    lw $s3, 0($t3)  
    
    beq $s3, 0, sold_out
    
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra
    
invalid_choice:
	li $v0, 4
    la $a0, invalid_number
    syscall
    jal loop_selection
    
sold_out:
	li $v0, 4
    la $a0, sold_out_dest
    syscall
    j loop_selection
    
commander_mode:
	
	li $v0, 4
	la $a0, enter_pin
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	bne $t0, 2025, denied
	j granted
	
	denied:
		li $v0, 4
		la $a0, access_denied
		syscall
		j commander_mode
		
	granted:
		li $v0, 4
		la $a0, access_granted
		syscall
	item1_cmd:
	li $v0, 4
    la $a0, set_seats
    syscall
    
    la $t0, names_array
    lw $a0, 0($t0)
    syscall
    
    li $v0, 4
    la $a0, current
    syscall
    
    la $t1, avalible_seats
    lw $a0, 0($t1)
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, close_paren_col
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0 
    
    blt $t2, 0, error_1
    
    sw $t2, 0($t1)
    
    li $v0, 4
    la $a0, msg_updated
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    j item2_cmd

	error_1:
    	li $v0, 4
    	la $a0, negative_qunt
    	syscall
    	j item1_cmd
    
   item2_cmd:
    li $v0, 4
    la $a0, set_seats
    syscall
    
    la $t0, names_array
    lw $a0, 4($t0)
    syscall
    
    li $v0, 4
    la $a0, current
    syscall
    
    la $t1, avalible_seats
    lw $a0, 4($t1)
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, close_paren_col
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0 
    
    blt $t2, 0, error_2
    
    sw $t2, 4($t1)
    
    li $v0, 4
    la $a0, msg_updated
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    j item3_cmd

	error_2:
    	li $v0, 4
    	la $a0, negative_qunt
    	syscall
    	j item2_cmd
    
    item3_cmd:
    li $v0, 4
    la $a0, set_seats
    syscall
    
    la $t0, names_array
    lw $a0, 8($t0)
    syscall
    
    li $v0, 4
    la $a0, current
    syscall
    
    la $t1, avalible_seats
    lw $a0, 8($t1)
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, close_paren_col
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0 
    
    blt $t2, 0, error_3
    
    sw $t2, 8($t1)
    
    li $v0, 4
    la $a0, msg_updated
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    j item4_cmd

	error_3:
    	li $v0, 4
    	la $a0, negative_qunt
    	syscall
    	j item3_cmd
    
    item4_cmd:
    li $v0, 4
    la $a0, set_seats
    syscall
    
    la $t0, names_array
    lw $a0, 12($t0)
    syscall
    
    li $v0, 4
    la $a0, current
    syscall
    
    la $t1, avalible_seats
    lw $a0, 12($t1)
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, close_paren_col
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0 
    
    blt $t2, 0, error_4
    
    sw $t2, 12($t1)
    
    li $v0, 4
    la $a0, msg_updated
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    j finished
    

	error_4:
    	li $v0, 4
    	la $a0, negative_qunt
    	syscall
    	j item4_cmd
    
    finished:
    	li $v0, 4
    	la $a0, msg_updates_done
    	syscall
    
    	j program_loop
    
	
	
InsertCredits:
    addi $sp, $sp, -12     
    sw   $ra, 0($sp)
    sw   $s0, 4($sp)  
    sw   $s1, 8($sp)  

    move $s0, $a0    
    li   $s1, 0
    li   $t2, 3
    
payment_loop:
    bge  $s1, $s0, payment_done

    beq  $t2, 0, payment_failed

    li $v0, 4
    la $a0, prompt_pay
    syscall

    li $v0, 5
    syscall
    move $t3, $v0
    
    beq  $t3, 1, add_credit
    beq  $t3, 5, add_credit
    beq  $t3, 10, add_credit
    beq  $t3, 20, add_credit
    
    j invalid_credit
    
    add_credit:
    	add $s1, $s1, $t3
    	
    	li $v0, 4
    	la $a0, total_inserted
    	syscall
    	
    	li $v0, 1
    	move $a0, $s1
    	syscall
    	
    	li $v0, 4
    	la $a0, credits
    	syscall
    	
    	j payment_loop
    	
    invalid_credit:
    	subi $t2, $t2, 1
    	li $v0, 4
    	la $a0, error_bill
    	syscall
    	
    	li $v0, 1
    	move $a0, $t2
    	syscall
    	
    	li $v0, 4
    	la $a0, newline 
    	syscall
    	
    	j payment_loop
    	
payment_failed:
	li $v0, 4
    la $a0, error_cancel
    syscall
    li $v0, -1
    j insert_exit
    
payment_done:
    move $v0, $s1
    
    
    
insert_exit:
    lw   $s1, 8($sp)
    lw   $s0, 4($sp)
    lw   $ra, 0($sp)
    addi $sp, $sp, 12
    jr   $ra
    
CalculateChange:
	addi $sp, $sp, -4
    sw   $ra, 0($sp)

    sub  $t0, $a1, $a0

    li   $v0, 4
    la   $a0, msg_change
    syscall

    li   $v0, 1
    move $a0, $t0
    syscall

    li   $v0, 4
    la   $a0, newline
    syscall

    lw   $ra, 0($sp)
    addi $sp, $sp, 4
	jr $ra
	
DispenseTicket:
	addi $sp, $sp, -4
    sw   $ra, 0($sp)
    
    lw   $t1, 0($a1)  
    subi $t1, $t1, 1 
    sw   $t1, 0($a1)
    
    move $t0, $a0

    li   $v0, 4
    la   $a0, msg_done
    syscall

    li $v0, 4
    move $a0, $t0  
    syscall

    li $v0, 4
    la $a0, msg_dispensed
    syscall
    
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
	jr $ra
	
exit_kiosk:
	li $v0, 4
    la $a0, exit_kiosk_msg
    syscall
    
    jal exit_program

exit_program:
    li $v0, 10
    syscall
    
    
    
    
    
    
    
    
    
    
    
