.data

menu_title:    .asciiz "\n=== Space Tourist Shuttle Kiosk ===\n"
item1:         .asciiz "1) Luna City - 75 credits\n"
item2:         .asciiz "2) Mars Dunes - 120 credits\n"
item3:         .asciiz "3) Europa Geysers - 90 credits\n"
item4:         .asciiz "4) Titan Lakes - 55 credits\n"
prompt_sel:    .asciiz "Please select a destination (1-4): "
invalid_number: .asciiz "Invalid choice. Please try again: \n"
total_inserted: .asciiz "Total inserted: "
credits: .asciiz " credits\n"
prompt_pay:    .asciiz "Insert bill (1, 5, 10, 20): "
error_bill:    .asciiz "Invalid bill! Attemps left: "
error_cancel:  .asciiz "Transaction canceled due to repeated invalid input.\n"
msg_change:    .asciiz "Change: "
msg_dispensed:    .asciiz " dispensed!\n"
msg_done:      .asciiz "Tickets to "
newline:       .asciiz "\n"

n_luna:    .asciiz "Luna City"
n_mars:    .asciiz "Mars Dunes"
n_europa:  .asciiz "Europa Geysers"
n_titan:   .asciiz "Titan Lakes"

names_array: .word n_luna, n_mars, n_europa, n_titan

prices:        .word 75, 120, 90, 55

.text
.globl main

main:
	
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
	
	move $a0, $s2
	jal DispenseTicket
	
	exit_program:
    	li $v0, 10
    	syscall
    
DisplayMenu:
	addi $sp, $sp, -4
    sw   $ra, 0($sp)

    li $v0, 4
    la $a0, menu_title
    syscall
    
    la $a0, item1
    syscall
    
    la $a0, item2
    syscall
    
    la $a0, item3
    syscall

    la $a0, item4
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


    blt $t0, 1, invalid_choice  
    bgt $t0, 4, invalid_choice


    la $t1, prices     
    sub $t0, $t0, 1    
    mul $t0, $t0, 4    
    add $t1, $t1, $t0  
    lw  $v0, 0($t1)    
    
    la  $t2, names_array
    add $t2, $t2, $t0
    lw  $v1, 0($t2)

    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra
    
invalid_choice:
	li $v0, 4
    la $a0, invalid_number
    syscall
    jal loop_selection
    
    
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
