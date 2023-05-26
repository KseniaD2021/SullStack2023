import { Controller, Get, Post, Body, Param, Delete } from '@nestjs/common';
import { OrdersService } from './orders.service';
import { Order } from './orders.entity';
import { identity } from 'rxjs';

@Controller()
export class OrdersController {
    public constructor(
        private readonly ordersService: OrdersService
    ) {}

    @Get('orders/:authId')
    public async getAllOrders(@Param('authId') authId: number): Promise<Order[]> {
        return (await this.ordersService.findAllOrders()).filter(order => order.authId == authId);
    }

    @Post('createOrder')
    public async createOrder(@Body() order: Order) : Promise<Boolean> {
        return this.ordersService.createOrder(order);
    }

    @Delete('order/:id')
    public async deleteById(@Param('id') id: number) : Promise<Boolean> {
        return this.ordersService.deleteOrderById(id);
    }
}