import { Controller, Get, Param, Put, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
import { Auth } from './auth.entity';

@Controller('')
export class AuthController {
    public constructor(
		private readonly authService: AuthService)
	{ }

    @Get('login')
    public async getLogins(): Promise<Auth[]> {
		return this.authService.login();
    }

    @Get('login/:login&:password')
    public async getLogin(@Param('login') login: string, @Param('password') password: string): Promise<Auth> {
        return (await this.authService.login()).find(item => (item.login == login && item.password == password));
    } 
}