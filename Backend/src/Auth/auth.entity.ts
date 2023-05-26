import { Column, Entity, PrimaryGeneratedColumn, OneToMany, JoinColumn } from "typeorm";

@Entity()
export class Auth{
    @PrimaryGeneratedColumn()
	public id!: number;

    @Column()
	public login: string;

	@Column()
	public password: string;
}